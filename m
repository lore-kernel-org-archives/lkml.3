Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3FEXOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:14:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47677 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757250Ab3FEXOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:14:05 -0400
Message-ID: <1370474043.2253.11.camel@joe-AO722>
Subject: Re: [PATCH] Staging: anrdroid: sync.c: fixed all checkpatch errors
 and warnings
From: Joe Perches <joe@perches.com>
To: Aldo Iljazi <neonsync1@gmail.com>
Cc: gregh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2013 16:14:03 -0700
In-Reply-To: <1370463827-6881-1-git-send-email-neonsync1@gmail.com>
References: <1370463827-6881-1-git-send-email-neonsync1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 23:23 +0300, Aldo Iljazi wrote:
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
[]
> @@ -893,13 +892,13 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
>  	if (obj->ops->timeline_value_str) {
>  		char value[64];
>  		obj->ops->timeline_value_str(obj, value, sizeof(value));
> -		seq_printf(s, ": %s", value);
> +		seq_puts(s, ": %s", value);

This is wrong and shouldn't compile without warning.

Is this an over aggressive conversion or did checkpatch
really complain on this line?  


