Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbaFIVBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:01:51 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47115 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbaFIVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:01:45 -0400
Date: Mon, 9 Jun 2014 14:01:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v2 1/3] x86, platform, xen, kconfig: move kvmconfig
 functionality to a helper
In-Reply-To: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com>
Message-ID: <alpine.DEB.2.02.1406091401080.30620@chino.kir.corp.google.com>
References: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Luis R. Rodriguez wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This can then be used by other virtual configs.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
