Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaETMMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:12:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:2109 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaETMM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,874,1392192000"; 
   d="scan'208";a="434467287"
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
References: <20140519211719.GA14563@logfs.org>
Date: Tue, 20 May 2014 05:12:07 -0700
In-Reply-To: <20140519211719.GA14563@logfs.org> (=?utf-8?Q?=22J=C3=B6rn?=
 Engel"'s message of
	"Mon, 19 May 2014 17:17:19 -0400")
Message-ID: <8761l0r6nc.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:
>
> An alternate high-resolution timer is the register content at the time
> of an interrupt. 

So if you interrupt a cryptographic function you may hash in parts
of the key?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
