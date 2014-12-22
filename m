Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaLVJUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:20:00 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:36502 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaLVJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:19:56 -0500
X-ASG-Debug-ID: 1419239084-0759e769b747c420002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 22 Dec 2014 10:04:38 +0100
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?utf-8?B?UmVuw6k=?= Moll <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 00/13] ltc2952 modernization and new functionality
Message-ID: <20141222090438.GA6427@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 00/13] ltc2952 modernization and new functionality
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.149]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1419239084
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: https://filter1.ibarracuda.nl:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.13245
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Wed, Oct 22, 2014 at 04:30:57PM +0200, Frans Klaver wrote:
> 
> This series implements devm_* usage, reduction of globals, some cleanup and
> finally makes the input trigger optional.

Has this fallen through the cracks?

Thanks,
Frans
