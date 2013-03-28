Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3C1KZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:25:15 -0400
Received: from skade.schwarzvogel.de ([144.76.18.87]:49143 "EHLO
	mail.schwarzvogel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3C1KZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:25:14 -0400
Date: Thu, 28 Mar 2013 11:25:11 +0100
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: Michael Cree <mcree@orcon.net.nz>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for
 kernel builds
Message-ID: <20130328102511.GA4658@skade.schwarzvogel.de>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	"linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
 <BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz>
 <20130325133710.GD14280@mudshark.cambridge.arm.com>
 <20130325150958.GA13894@skade.schwarzvogel.de>
 <D7731577-A2C0-4FC5-A7E3-62F251A18798@orcon.net.nz>
 <20130327175631.GA99121@skade.schwarzvogel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327175631.GA99121@skade.schwarzvogel.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! 

On a whim, I tried fiddling with ALPHA_LEGACY_START_ADDRESS.
While this necessitates switching the system type  to
GENERIC_ALPHA, it makes the whole thing work. I suspect the
change in segment size shifted stuff around enough to make the
DP264 layout a "legacy" one. 

Regards,
Tobias


-- 
Sent from aboard the Culture ship
	ROU (Killer-class) Trade Surplus
