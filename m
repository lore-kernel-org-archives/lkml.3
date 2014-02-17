Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBQUl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:41:26 -0500
Received: from nm43-vm8.bullet.mail.bf1.yahoo.com ([216.109.114.239]:39164
	"EHLO nm43-vm8.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbaBQUlY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:41:24 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 15:41:24 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 652749.14135.bm@omp1056.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Tt0uI9VJEiqqOKWnzO6ZFLRnvlOPG2tR9HQsjLEZrOBPxsdJ9021DPrfe+niD7cC5NzCSRIQ8KQfFmrq0/Dvd7xEHn/AVLYDDWyILN3cqeP29F8kUBTJnKM8P/yRuQXYCO+tjQEkJz6HRrpR+UCmhXzta2K9XHox/hR6ef3NMY4=;
X-YMail-OSG: Q3L6OLMVM1kZD07cysC8u1t08CRrsPqYokml9VYtxk5B.7M
 BwXaLcB_rRhZzOIIjdbxGkwfkmGav8WG5ffWOa6ZlrJHPM_F4z9fhQRPtxLY
 v4riQY5xWO2U4KCT9LbT3YOHi8.ngxD37Kc90p4qTbE60bZ.AkyKPVS2Z8vk
 R2ionLk6fyB41WzBQzyRrPDToeIukYHIuV_py3EQo0IuPkg02hYnyNeH_yhn
 6ziirn5FzTocImr2yHbD_b991EGYzBsBjco.YE0SsNAIdVN4lVjWsgaOz1LI
 OjmGbazy2NI8lFjtLy4G.B3vAXNzFtm0BAUqDjvrXN_oq_UsSrlhG3Z_f.ZM
 CiyT1QcdA0M8j5MCiOfMxBl8KoKsPtM7M0TmU6RZs5pnfVPquNVInmRjuwXo
 4_JzwIdrBjHMNOCp3rfaumJ0ksJwQrVdVLmIC1k8_oNg6krq3CVk3FQEJcuM
 ZaltVF4MSdvnr_BNPTVHOtY_hFzHvV2w6J8nqqGPYDpxFz.ERf1XT1AfTyop
 HV5YkhLzYtWO2ezY4_CYyzBgZ6qtkVEHAjpQs7qoPx298gaeuBE2T9JwXIG4
 _2F5a0rA0OkWfF5odXt8-
X-Rocket-MIMEInfo: 002.001,CgoKCi0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0KPiBGcm9tOiBUcm9uZCBNeWtsZWJ1c3QgPHRyb25kLm15a2xlYnVzdEBwcmltYXJ5ZGF0YS5jb20.Cj4gVG86IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPjsgTGludXggTkZTIE1haWxpbmcgTGlzdCA8bGludXgtbmZzQHZnZXIua2VybmVsLm9yZz4KPiBDYzogSm9obiA8ZGFfYXVkaW9waGlsZUB5YWhvby5jb20.OyBsa21sIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgIm5ldGRldkB2Z2VyLmtlcm5lbC5vcmciIDxuZXRkZXZAdmcBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com>	 <1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com>	 <20140215203015.GA4528@pd.tnic>	 <1392498262.98385.YahooMailNeo@web140003.mail.bf1.yahoo.com>	 <20140215232508.GB4508@pd.tnic> <1392571653.44773.4.camel@leira.trondhjem.org>
Message-ID: <1392669351.46253.YahooMailNeo@web140005.mail.bf1.yahoo.com>
Date: Mon, 17 Feb 2014 12:35:51 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
To: Trond Myklebust <trond.myklebust@primarydata.com>,
        Borislav Petkov <bp@alien8.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mlindner@marvell.com" <mlindner@marvell.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <1392571653.44773.4.camel@leira.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: Trond Myklebust <trond.myklebust@primarydata.com>
> To: Borislav Petkov <bp@alien8.de>; Linux NFS Mailing List <linux-nfs@vger.kernel.org>
> Cc: John <da_audiophile@yahoo.com>; lkml <linux-kernel@vger.kernel.org>; "netdev@vger.kernel.org" <netdev@vger.kernel.org>; "stephen@networkplumber.org" <stephen@networkplumber.org>; "mlindner@marvell.com" <mlindner@marvell.com>; J. Bruce Fields <bfields@fieldses.org>
> Sent: Sunday, February 16, 2014 12:27 PM
> Subject: Re: [BUG] unable to handle kernel NULL pointer dereference
> 
> Please ensure that you post to the linux-nfs@vger.kernel.org when
> reporting NFS and RPC related bugs.
> 
> Does the following patch help?
> 
> 8<-------------------------------------------------------------------
> From 0e57b109cd7b17d6e6f16c3454427372a583b18a Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <trond.myklebust@primarydata.com>
> Date: Sun, 16 Feb 2014 12:14:13 -0500
> Subject: [PATCH] SUNRPC: Ensure that gss_auth isn't freed before its upcall
> messages
> 
> Fix a race in which the RPC client is shutting down while the
> gss daemon is processing a downcall. If the RPC client manages to
> shut down before the gss daemon is done, then the struct gss_auth
> used in gss_release_msg() may have already been freed.
> 
> Link: 
> http://lkml.kernel.org/r/1392494917.71728.YahooMailNeo@web140002.mail.bf1.yahoo.com
> Reported-by: John <da_audiophile@yahoo.com>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
> ---
> net/sunrpc/auth_gss/auth_gss.c | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 44a61e8fda6f..1ba1fd114912 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -108,6 +108,7 @@ struct gss_auth {
> static DEFINE_SPINLOCK(pipe_version_lock);
> static struct rpc_wait_queue pipe_version_rpc_waitqueue;
> static DECLARE_WAIT_QUEUE_HEAD(pipe_version_waitqueue);
> +static void gss_put_auth(struct gss_auth *gss_auth);
> 
> static void gss_free_ctx(struct gss_cl_ctx *);
> static const struct rpc_pipe_ops gss_upcall_ops_v0;
> @@ -320,6 +321,7 @@ gss_release_msg(struct gss_upcall_msg *gss_msg)
>     if (gss_msg->ctx != NULL)
>         gss_put_ctx(gss_msg->ctx);
>     rpc_destroy_wait_queue(&gss_msg->rpc_waitqueue);
> +    gss_put_auth(gss_msg->auth);
>     kfree(gss_msg);
> }
> 
> @@ -500,6 +502,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
>         if (err)
>             goto err_free_msg;
>     };
> +    kref_get(&gss_auth->kref);
>     return gss_msg;
> err_free_msg:
>     kfree(gss_msg);
> @@ -1064,6 +1067,12 @@ gss_free_callback(struct kref *kref)
> }
> 
> static void
> +gss_put_auth(struct gss_auth *gss_auth)
> +{
> +    kref_put(&gss_auth->kref, gss_free_callback);
> +}
> +
> +static void
> gss_destroy(struct rpc_auth *auth)
> {
>     struct gss_auth *gss_auth = container_of(auth,
> @@ -1084,7 +1093,7 @@ gss_destroy(struct rpc_auth *auth)
>     gss_auth->gss_pipe[1] = NULL;
>     rpcauth_destroy_credcache(auth);
> 
> -    kref_put(&gss_auth->kref, gss_free_callback);
> +    gss_put_auth(gss_auth);
> }
> 
> /*
> @@ -1255,7 +1264,7 @@ gss_destroy_nullcred(struct rpc_cred *cred)
>     call_rcu(&cred->cr_rcu, gss_free_cred_callback);
>     if (ctx)
>         gss_put_ctx(ctx);
> -    kref_put(&gss_auth->kref, gss_free_callback);
> +    gss_put_auth(gss_auth);
> 
> }
> 
> static void
> -- 


Tested-by: John <da_audiophile@yahoo.com>


Fixes the problem on 3.13.3 for me (i686). Thank you.
