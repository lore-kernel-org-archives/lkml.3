Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3IJOTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:19:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:59240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3IJOTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,878,1371106800"; 
   d="scan'208";a="393614301"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Vetter <daniel@ffwll.ch>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
In-Reply-To: <1378821416.17982.56.camel@x230.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <522D88C3.7000808@intel.com> <1793135.3qk7NfcINN@vostro.rjw.lan> <20130909152118.GG27291@phenom.ffwll.local> <5155010.Y1gov7SKhP@vostro.rjw.lan> <87eh8wail7.fsf@intel.com> <1378821416.17982.56.camel@x230.lan>
User-Agent: Notmuch/0.16+63~g12e17e8 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 10 Sep 2013 17:21:41 +0300
Message-ID: <87bo40ahai.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Matthew Garrett <matthew.garrett@nebula.com> wrote:
> On Tue, 2013-09-10 at 16:53 +0300, Jani Nikula wrote:
>
>> I think the parameter "Does the ACPI backlight interface work or not"
>> belongs to the ACPI video driver.
>
> That depends on how Windows 8 works. If Windows 8 policy is handled by
> the GPU drivers then it belongs in i915. If it's handled by the ACPI
> code then it belongs in the ACPI code.

I fail to see the logic. Windows 8 policy dictates whether we can use
the AML code or not. IMHO, ACPI code is in the best position to figure
this out and quirk as necessary. It's the part that knows about Windows
8, not i915.

> But I have no way of determining that, whereas you work for a company
> that produces a Windows 8 video driver…

Here I do see the logic. However see signature; I'm not in the best of
positions to figure out things about Windows 8 video drivers. ;) But
I'll see what I can do.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
