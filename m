Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3KTJKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:10:44 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35628 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3KTJKi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 20 Nov 2013 04:10:38 -0500
Message-Id: <528C8A980200007800104E69@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 20 Nov 2013 09:10:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bob Liu" <lliubbo@gmail.com>
Cc: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        "Bob Liu" <bob.liu@oracle.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [PATCH] xen: tmem: rmove useless parameters
References: <1384937575-25168-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1384937575-25168-1-git-send-email-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.11.13 at 09:52, Bob Liu <lliubbo@gmail.com> wrote:
> @@ -100,9 +100,6 @@ static inline int xen_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
>  	op.u.gen.oid[1] = oid.oid[1];
>  	op.u.gen.oid[2] = oid.oid[2];
>  	op.u.gen.index = index;
> -	op.u.gen.tmem_offset = tmem_offset;
> -	op.u.gen.pfn_offset = pfn_offset;
> -	op.u.gen.len = len;

But you can't leave these fields uninitialized.

Jan

