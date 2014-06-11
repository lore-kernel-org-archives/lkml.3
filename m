Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaFKTpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:45:33 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:38128 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:45:32 -0400
Date: Wed, 11 Jun 2014 21:45:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@fedoraproject.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86,vdso: Fix vdso_install
Message-ID: <20140611194528.GB25049@ravnborg.org>
References: <sam@ravnborg.org>
 <5d5e221e59be20a3a7ceb99452e74e233383e7b4.1402514715.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5e221e59be20a3a7ceb99452e74e233383e7b4.1402514715.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:25:29PM -0700, Andy Lutomirski wrote:
> The filenames are different now.  Inspired by a patch from
> Sam Ravnborg.
> 
> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Better than the first version - thanks!

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
