Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbALNUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:20:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbbALNUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:20:50 -0500
Message-ID: <54B3CA2A.2030004@redhat.com>
Date: Mon, 12 Jan 2015 08:20:42 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Update git commit message
References: <1420840730.32628.13.camel@perches.com>
In-Reply-To: <1420840730.32628.13.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 04:58 PM, Joe Perches wrote:
> The git commit message can be confusing,
> 
> Try to clarify the message a bit to reduce
> the confusion when emitted.
> 
> Show the correct form using
> 	Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")'
> and if the git commit sha1 is unique, show
> the right sha1 to use with the actual title
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Original-patch-by: Prarit Bhargava <prarit@redhat.com>
> ---

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
