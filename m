Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3HOKDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:03:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3HOKC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:02:57 -0400
Date: Thu, 15 Aug 2013 12:02:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815100255.GD27616@pd.tnic>
References: <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com>
 <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan>
 <520A6A30.1030406@linux.vnet.ibm.com>
 <20130814205638.1ebcfd3e@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130814205638.1ebcfd3e@concha.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:56:38PM -0300, Mauro Carvalho Chehab wrote:
> Better to spend a little more time discussing than implementing a new trace
> that will be removed on a near future.

Right, "in the meantime" we established that this new TP doesn't bring
us anything new so we might just as well use trace_mc_event and call it
either straight from APEI or in ghes_edac.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
