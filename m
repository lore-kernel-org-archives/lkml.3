Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbaJVMVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:21:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:3619 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbaJVMVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,768,1406617200"; 
   d="scan'208";a="623151059"
From: Jani Nikula <jani.nikula@intel.com>
To: Daniel Exner <dex@dragonslave.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: Regression in i915 intel_panel_setup_backligh
In-Reply-To: <542F0546.6040604@dragonslave.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 15:21:31 +0300
Message-ID: <87tx2wthv8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This is in reply to https://lkml.org/lkml/2014/10/3/415 - I just don't
have the message to reply to.]

Daniel, the bug you describe is likely [1]. We're on it.

Thanks,
Jani.


[1] https://bugzilla.kernel.org/show_bug.cgi?id=86551

-- 
Jani Nikula, Intel Open Source Technology Center
