Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaFWGLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:11:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:57204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaFWGLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:11:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,528,1400050800"; 
   d="scan'208";a="532518501"
Date: Sun, 22 Jun 2014 23:11:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, bp@alien8.de,
        x86@kernel.org
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140623061151.GA8178@tassilo.jf.intel.com>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A46365.6090101@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We probably should just the cpu_has_mp macro entirely.  All it is used
> for is printing a warning in amd_k7_smp_check().
> 
> Andi, Borislav -- as far as I can tell, we have *never* enforced this on
> the 64-bit kernel, although we have enforced it on 64-bit processors
> running the 32-bit kernel.  We should either enforce it on both or just
> drop it.  What is your opinion?

Drop it everywhere.

-Andi
