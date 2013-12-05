Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3LEPL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:11:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32293 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3LEPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:11:26 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-46-52a0979c230e
From: Tomasz Figa <t.figa@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kevin Bracey <kevin@bracey.fi>,
        Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
Date: Thu, 05 Dec 2013 16:11:15 +0100
Message-id: <1502243.eRBlCfUhTO@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <20131205150747.GW29268@sirena.org.uk>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
 <20131205150747.GW29268@sirena.org.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Fd050xcEGfRP5bCY+vAJm8X8I+dY
	Lc4uO8hm8f/Ra1aL0yv2slr0LrjKZnHr8ioWiyl/ljNZbHp8jdXi8q45bBYzzu9jslh75C67
	xauDbSwWx2YsYXTg8/h/tY3RY3bDRRaPzSu0PDat6mTzuHNtD5vH5iX1Hn1bVjF6bL82j9nj
	8yY5j41zQwO4orhsUlJzMstSi/TtErgyvi58ylpwgKXi7dUTbA2Mh5i7GDk5JARMJGb97mKC
	sMUkLtxbz9bFyMUhJLCUUeL3/8+MEE4Xk8SZdetZQarYBNQkPjc8YgOxRQSUJa5+38sCUsQs
	0MYqsXHvA7AiYYFIiVc7WsFsFgFViZev/gIVcXDwCmhK7PivDBLmF1CXeLftKdhmUQE3iRf7
	trCD2JwCxhJXuk+zQizexChxZ/EOsASvgKDEj8n3WEBsZgF5iX37p7JC2FoS63ceZ5rAKDgL
	SdksJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESc193MC49ZnWIUYCDUYmH
	1zFlfpAQa2JZcWXuIUYJDmYlEV71jgVBQrwpiZVVqUX58UWlOanFhxiZODilGhjLRN+9s7Gu
	T5K2Kddky01L3F3W5CR5LE3N6ql4nOBdLvfOW5llkzYvFeVMTr27u+BX8dt7bu+t09+pLSrR
	jO2+uKzk++vanvs90kf98/If1upXSek//MTrsDs10uyw2cSwj0xBCz8yaUxY/sKdTzXOwXyP
	+qRVWQc3bJ5kIxB02aloMltWlBJLcUaioRZzUXEiAORP7LeXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 of December 2013 15:07:47 Mark Brown wrote:
> On Tue, Dec 03, 2013 at 10:29:42AM +0100, Linus Walleij wrote:
> 
> > So a suggested patch to support weak hogs would be interesting
> > to look at. Can you provide details on how you think this would
> > work?
> 
> Or should we be going and applying the default state to all devices on
> init without worrying about a driver appearing?

If a device isn't used, then it's often better to configure the pins for
a different function, such as GPIO, to minimize leakage current.

Best regards,
Tomasz

