Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbaJaKxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:53:05 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:34831 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaJaKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:53:04 -0400
X-ASG-Debug-ID: 1414752780-0759e77584174ec0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Fri, 31 Oct 2014 11:52:39 +0100
From: Frans Klaver <frans.klaver@xsens.com>
To: Roy Spliet <rspliet@eclipso.eu>
CC: <bskeggs@redhat.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] nouveau dual monitor setup broken
Message-ID: <20141031105239.GA6086@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [bisected] nouveau dual monitor setup broken
References: <20141031075449.GA6170@ci00147.xsens-tech.local>
 <0c9233023d2d4873f91fd2731bac603e@mail.eclipso.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <0c9233023d2d4873f91fd2731bac603e@mail.eclipso.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1414752781
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.11072
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:34:45AM +0100, Roy Spliet wrote:
> 
> It does ring a tiny bell: please check out https://bugs.freedesktop.org/show_bug.cgi?id=85160 and try the fix proposed in comment #7.

Yup, that seems to fix things. As far as I'm concerned, that patch is

Tested-by: Frans Klaver <frans.klaver@xsens.com>

Thanks,
Frans
