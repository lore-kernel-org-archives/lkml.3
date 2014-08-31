Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHaRNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:13:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:64288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaHaRNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,436,1406617200"; 
   d="scan'208";a="595924830"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Sun Wang <743559269@qq.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Pershin, Mike" <mike.pershin@intel.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Chris Horn <hornc@cray.com>,
        Kristina Martsenko <kristina.martsenko@gmail.com>,
        Alexey Lyashkov <alexey_lyashkov@xyratex.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Masanari Iida <standby24x7@gmail.com>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: lustre: ptlrpc: events: fix coding
 style issue 
Thread-Topic: [PATCH] staging: lustre: lustre: ptlrpc: events: fix coding
 style issue 
Thread-Index: AQHPxT29h7YWOL8ulki8EMgwHVzqO5vraJ4A
Date: Sun, 31 Aug 2014 17:13:27 +0000
Message-ID: <E9D1EF94-A221-4200-BE5F-8101BBC1475B@intel.com>
References: <1409504548-26650-2-git-send-email-743559269@qq.com>
In-Reply-To: <1409504548-26650-2-git-send-email-743559269@qq.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.38.158]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78C863E522B5A24895795608C1FFEAEF@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently this was already fixed by commit 1d8cb70c7bdda47125ed551fc390aa9597c5f264 a few days ago.

On Aug 31, 2014, at 1:02 PM, Sun Wang wrote:

> From: sunwxg <743559269@qq.com>
> 
> Coding style issues, the changes include:
> -Add sapce after ','
> 
> Signed-off-by: Sun Wang <743559269@qq.com>
> 
> ---
> drivers/staging/lustre/lustre/ptlrpc/events.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
> index c3ec21d..ed811ef 100644
> --- a/drivers/staging/lustre/lustre/ptlrpc/events.c
> +++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
> @@ -186,7 +186,8 @@ void client_bulk_callback(lnet_event_t *ev)
> 	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB, CFS_FAIL_ONCE))
> 		ev->status = -EIO;
> 
> -	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,CFS_FAIL_ONCE))
> +	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,
> +				CFS_FAIL_ONCE))
> 		ev->status = -EIO;
> 
> 	CDEBUG((ev->status == 0) ? D_NET : D_ERROR,
> @@ -481,7 +482,7 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
> 		}
> 	}
> 
> -	CDEBUG(D_NET,"%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
> +	CDEBUG(D_NET, "%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
> 	return rc;
> }
> 
> 

