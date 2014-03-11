Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaCKODn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:03:43 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:57455 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaCKODm (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 11 Mar 2014 10:03:42 -0400
Subject: Re: [PATCH] crypto: avoid module request when lookup crypto larval
 of template
From: joeyli <jlee@suse.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140310115721.GA9657@gondor.apana.org.au>
References: <1394443371-12181-1-git-send-email-jlee@suse.com>
	 <20140310115721.GA9657@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Mar 2014 22:02:58 +0800
Message-ID: <1394546578.26565.43.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert, 

於 一，2014-03-10 於 19:57 +0800，Herbert Xu 提到：
> On Mon, Mar 10, 2014 at 05:22:51PM +0800, Lee, Chun-Yi wrote:
> > When allocate crypto algorithms, e.g. crypto_alloc_shash(), using
> > template model will run into the path that call module_request().
> > But there have no any module alias that match with the template name.
> 
> There aren't any but there could be.  For example, as it is
> all direct implementations of cbc(aes) rely on the fact that
> they also happen to provide aes to autoload themselves.
> 
> We may well have a case where it makes sense for a module to
> provide just cbc(aes) for example, in which case it would need
> such an alias for it to be loaded automatically.
> 
> Thanks,

Thanks for your quick explanation!

Joey Lee

