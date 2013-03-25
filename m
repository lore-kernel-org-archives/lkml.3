Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3CYUHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:07:01 -0400
Received: from nctlincom02.orcon.net.nz ([60.234.4.76]:55265 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab3CYUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:07:00 -0400
Cc: "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <D7731577-A2C0-4FC5-A7E3-62F251A18798@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Tobias Klausmann <klausman@schwarzvogel.de>
In-Reply-To: <20130325150958.GA13894@skade.schwarzvogel.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for kernel builds
Date: Tue, 26 Mar 2013 09:06:44 +1300
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com> <BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz> <20130325133710.GD14280@mudshark.cambridge.arm.com> <20130325150958.GA13894@skade.schwarzvogel.de>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx1.orcon.net.nz on Tue, 26 Mar 2013 09:06:57 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 26 09:06:57 2013
X-DSPAM-Confidence: 0.6186
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0006 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=130.217.188.11; country=NZ; region=G1; city=Hamilton; latitude=-37.7833; longitude=175.2833; http://maps.google.com/maps?q=-37.7833,175.2833&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05JfU6V8t - 60cc7263fe1a - 20130326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2013, at 4:09 AM, Tobias Klausmann wrote:
> On Mon, 25 Mar 2013, Will Deacon wrote:
>> Any news on these? I've included an updated version of the first  
>> patch, with
>> the Tested-by-tag and a tweaked commit message below.
>
> As a data point, I tried vanilla 3.8.4 on the weekend. With my
> usual config on a UP1500, it will fail at build time with
> relocation errors. If I remove -msmall-data (or replace it with
> ~big~), the machine hangs hard immediatly after aboot telling me
> it's starting it.

You probably want the "alpha: Add irongate_io to to PCI bus resources"  
patch posted by Matt Turner in the linux-alpha forum.  Looks like it  
has not been sent to Linus.

If Matt does not respond in the next day or two I'll collect patches  
and send them on to Linus.

Cheers
Michael.



