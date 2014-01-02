Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaABPAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:00:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38536 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:00:52 -0500
Date: Thu, 2 Jan 2014 18:00:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        pavel@ucw.cz, pali.rohar@gmail.com
Subject: Re: [PATCH v2] Staging: tidspbridge: Use hashtable implementation
Message-ID: <20140102150042.GA30234@mwanda>
References: <20131227094532.GA17143@amd.pavel.ucw.cz>
 <1388159914-4132-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388159914-4132-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	u32 val_size;
> +	DECLARE_HASHTABLE(hash_table, GH_HASH_ORDER);
> +	u32 (*hash)(void *);
> +	bool (*match)(void *, void *);
> +	void (*delete)(void *);

I forgot to say, put the parameter name in the declaration.

+	u32 (*hash)(void *key);
+	bool (*match)(void *key, void *result);
+	void (*delete)(void *key);

I have no idea if those names are correct.

regards,
dan carpenter
