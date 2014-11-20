Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaKTMe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:34:28 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58697 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKTMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:34:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Thu, 20 Nov 2014 13:33:43 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, arm@kernel.org
References: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com> <54616557.1010403@amd.com> <20141113110002.GE20652@localhost>
In-Reply-To: <20141113110002.GE20652@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201333.44180.arnd@arndb.de>
X-Provags-ID: V02:K0:W0zcMigFDX0dtvltXAFP1298wm3Y6byC604fot0sS2w
 4946u59XQk13Oxvemra2Vtxy2NA0svuoOXiEWHGC4a97cw3vD+
 63pDoEDkNkCeejBx9I4HtFREOL/VElAvNORg4VYxMKLgbr9xMy
 /uKJt73x/dUIGY4LD4AcI6oY2noJ1GYWG6oUueLNWdS5tnkkGw
 cxPDJ6YET3C2axmLl5XF3Lk2afKOS/4SusAPv5yYgSlqPzgHot
 IHoaesfokqHKqVoZQF5n9nkhaz8rrsIJTLtrfxeS1huaOTYEpW
 ks5LoSsqE1UnxvgaFMR5ThIpOWDJkmtkZPFEb12L4ETnT1Nvnk
 Qyln+4f6M5qzZZQNLGsZQ63ux8zsmoOSSJY36Q3LG
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014, Catalin Marinas wrote:
> On Tue, Nov 11, 2014 at 01:24:39AM +0000, Suravee Suthikulpanit wrote:
> > Are there any other concerns about this patch?
> 
> Let's cc the arm-soc guys, they are now handling SoC code for arm64.

Any update on the submission? I had some comments, am now waiting for a new
version to put into 3.19.

	Arnd
