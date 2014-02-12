Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBLFUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:20:46 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36222 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBLFUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:20:45 -0500
Date: Tue, 11 Feb 2014 21:20:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Subject: Re: [GIT PULL] x86, apic: Remove support for Summit and ES7000
In-Reply-To: <52FAF8AD.1000800@zytor.com>
Message-ID: <alpine.DEB.2.02.1402112119240.8750@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com> <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
 <52FAF8AD.1000800@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, H. Peter Anvin wrote:

> Nice.
> 

Natalie emailed me and said she agrees with the removal of es7000.  
Matthew's email address bounces, so summit is orphaned and the email 
address in its header is obsolete.
