Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbaJaWLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:11:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:45912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaJaWLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:11:01 -0400
Date: Fri, 31 Oct 2014 23:10:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@linux.intel.com, qiaowei.ren@intel.com, fenghua.yu@intel.com
Subject: Re: [PATCH] [v2] x86 mpx: give bndX registers actual names
In-Reply-To: <20141031215820.5EA5E0EC@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1410312304380.5308@nanos>
References: <20141031215820.5EA5E0EC@viggo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Dave Hansen wrote:

> 
> Changes from V1:
>  * name it 'bndreg' instead plain 'bnd'

Peter wanted you to do s/struct bndreg_struct/struct bndreg/

Which makes a lot of sense as there is no point of having the extra
_struct. Except you are part of the 

   bndreg_struct_t *ptrStructBndregStruct_p;

universe :)

Thanks,

	tglx


