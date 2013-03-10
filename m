Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3CJKSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:18:14 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:54772 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964Ab3CJKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:18:12 -0400
Date: Sun, 10 Mar 2013 18:17:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, rob@landley.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: Re: [RESEND PATCH 6/6] doc: Fix a wrong comment in
 Documentation/hw_random.txt
Message-ID: <20130310101756.GH10910@gondor.apana.org.au>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
 <1362652697-30284-7-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362652697-30284-7-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 06:38:17PM +0800, Tang Chen wrote:
> Seeing from the comment, there should be three reasons for removing request_mem_region.
> Change the comment "two" to "three".
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Acked-by: Rob Landley <rob@landley.net> 

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
