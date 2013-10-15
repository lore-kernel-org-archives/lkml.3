Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab3JONlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:41:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52601 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab3JONlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:41:19 -0400
Date: Tue, 15 Oct 2013 15:41:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        LKML <linux-kernel@vger.kernel.org>, acme@redhat.com,
        dhowells@redhat.com, gthelen@google.com,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v1] tools/thermal: Introduce tmon, a tool for thermal
 subsystem
Message-ID: <20131015134106.GC8682@pd.tnic>
References: <1381791747-7458-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1381791747-7458-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20131015091401.GA8013@pd.tnic>
 <20131015063154.3f7eb99c@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015063154.3f7eb99c@ultegra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 06:31:54AM -0700, Jacob Pan wrote:
> hmm, i did that. what version of kernel did you use checkpatch?

Try ... checkpatch.pl --strict ...

Although they're only checks, some of them do make sense :).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
