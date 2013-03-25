Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3CYP3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:29:09 -0400
Received: from skade.schwarzvogel.de ([144.76.18.87]:36137 "EHLO
	mail.schwarzvogel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab3CYP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:29:08 -0400
X-Greylist: delayed 1147 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 11:29:08 EDT
Date: Mon, 25 Mar 2013 16:09:58 +0100
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for
 kernel builds
Message-ID: <20130325150958.GA13894@skade.schwarzvogel.de>
Mail-Followup-To: "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
 <BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz>
 <20130325133710.GD14280@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130325133710.GD14280@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! 

On Mon, 25 Mar 2013, Will Deacon wrote:
> Any news on these? I've included an updated version of the first patch, with
> the Tested-by-tag and a tweaked commit message below.

As a data point, I tried vanilla 3.8.4 on the weekend. With my
usual config on a UP1500, it will fail at build time with
relocation errors. If I remove -msmall-data (or replace it with
~big~), the machine hangs hard immediatly after aboot telling me
it's starting it. I'll take a closer look later today, but there
seems to be a very fundamental thing wrong with the startup code
in these scenarios.

Regards,
Tobias

-- 
"Brain, konban wa nani o shimashitai?"
"Your Japanese is terrible, Pinky."
