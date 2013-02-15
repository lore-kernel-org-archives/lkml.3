Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3BOXeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:34:46 -0500
Received: from plane.gmane.org ([80.91.229.3]:54070 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3BOXep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:34:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Grosshaeuser <michael.grosshaeuser@t-online.de>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume at 100%
Date: Fri, 15 Feb 2013 23:30:04 +0000 (UTC)
Message-ID: <loom.20130216T002002-269@post.gmane.org>
References: <50BDF345.60804@gmail.com> <1354630272.2480.4.camel@rzhang1-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 93.220.160.7 (Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui <rui.zhang <at> intel.com> writes:

> 
> Hi, Roberto,
> 
> please attach the acpidump output.
> 
> On Tue, 2012-12-04 at 13:57 +0100, Roberto Oppedisano wrote:
> > Hello,
> >      with recent kernels after a suspend/resume cycle on my laptop (HP 
> > 6730b) the fans stays at full speed.
> does the fan keep running at full speed after resume?
> 
> please attach the output of "grep . /sys/class/thermal/*/*" before
> suspend and when the fan is running at full speed.
> please attach the same stuff in a good kernel.
> 
> thanks,
> rui
> 

Hi,

any update for this bug? This also breaks on my HP 2510p.

Best regards,
Michael


