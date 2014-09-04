Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaIDJ12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:27:28 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:45253 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaIDJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:27:06 -0400
X-ASG-Debug-ID: 1409822824-0759e778ba691770002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Thu, 4 Sep 2014 11:26:50 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Johan Hovold <johan@kernel.org>
CC: Frans Klaver <fransklaver@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
Message-ID: <20140904092650.GB6213@ci00147.test>
X-ASG-Orig-Subj: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
References: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
 <1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
 <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
 <20140904081522.GD4894@localhost>
 <20140904090546.GA6213@ci00147.test>
 <20140904092226.GE4894@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140904092226.GE4894@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1409822824
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9163
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:22:26AM +0200, Johan Hovold wrote:
> On Thu, Sep 04, 2014 at 11:05:47AM +0200, Frans Klaver wrote:
> > 
> > The new version is applied, built and tested with some actual hardware
> > on 3.17-rc3.
> 
> Good. Both patches applied now.

Thanks again,
Frans
