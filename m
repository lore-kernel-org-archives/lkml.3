Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaFYSI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:08:27 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49789 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbaFYSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:08:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, linux-tegra@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
Date: Wed, 25 Jun 2014 20:07:37 +0200
Message-ID: <44039675.8s16pHQIVH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
References: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VDQul4P2UT8cMF4cNfI9TUOria8Jatg71lFwWXnBq8V
 mWWVczn8H23W+tuzxcHrOC4he2rGfecKAH4RIs92du+dMj6dkz
 zXgTqaogFo+UgOsYEz0yVkhzdr+UcpFv/e+P2NUXbfHZvcZoUO
 SxNh2WsIkSNyB4nZ93qxNk81qLUIe1ESSusaV+d/Iwg6qqjcrs
 +tszvrXLSkcfLYoxliYBBmwvFtZ4WXKWtll0rMbHIsgUulqQn+
 AtJ8OU6MAH2yVwLdSYuQ7Q6/GSHv1xssJaoOYVjy/UMuBTRJ20
 bC2rd5p/pSKmQB6lRim7mtc227XFnNaD7OhKp4ZhSM23Ges+b6
 /P4RnKhuZvMfeoSdTQh0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 19:26:31 Peter De Schrijver wrote:
> Define and export a new function __clk_get_debug which returns the debugfs
> directory entry pointer. This can be used by clock providers to add debugfs
> entries which are not related to a specific clock type. Examples include the
> ability to measure the rate of a clock. It can also be used by modules to
> create new debugfs entries. This is useful if you want to expose features
> for testing which can potentially cause system instability such as allowing
> to change a clock's rate from userspace.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 

Just an idea, but would it be better to add a pair of functions to add/remove
debugfs files rather than exposing the dentry itself?

	Arnd
