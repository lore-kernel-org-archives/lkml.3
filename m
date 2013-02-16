Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab3BPG7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 01:59:50 -0500
Received: from plane.gmane.org ([80.91.229.3]:38545 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab3BPG7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 01:59:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: auxsvr@gmail.com
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume at 100%
Date: Sat, 16 Feb 2013 08:55:10 +0200
Message-ID: <kfnagc$6tu$1@ger.gmane.org>
References: <50BDF345.60804@gmail.com> <1354630272.2480.4.camel@rzhang1-mobl4> <loom.20130216T002002-269@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cust-27-63.on5.ontelecoms.gr
User-Agent: KNode/4.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Grosshaeuser wrote:

> Zhang Rui <rui.zhang <at> intel.com> writes:
> 
>> 
>> Hi, Roberto,
>> 
>> please attach the acpidump output.
>> 
>> On Tue, 2012-12-04 at 13:57 +0100, Roberto Oppedisano wrote:
>> > Hello,
>> >      with recent kernels after a suspend/resume cycle on my laptop (HP
>> > 6730b) the fans stays at full speed.
>> does the fan keep running at full speed after resume?
>> 
>> please attach the output of "grep . /sys/class/thermal/*/*" before
>> suspend and when the fan is running at full speed.
>> please attach the same stuff in a good kernel.
>> 
>> thanks,
>> rui
>> 
> 
> Hi,
> 
> any update for this bug? This also breaks on my HP 2510p.

Also on HP Mini 5102.

> Best regards,
> Michael

Best regards,
Peter

