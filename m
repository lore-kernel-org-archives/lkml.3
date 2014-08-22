Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHVUr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:47:57 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49283 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaHVUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:47:54 -0400
Message-ID: <1408740472.24496.5.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] target: target_core_transport.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 13:47:52 -0700
In-Reply-To: <1407102622-8806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1407102622-8806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On Sun, 2014-08-03 at 23:50 +0200, Rickard Strandqvist wrote:
> Ensures that the string is null-terminate in connection with the
> use of strncpy. Optimized code by replacing unnecessary sprintf
> with strlcat and more, and simultaneously guarantees that the
> string does not get bigger than sizeof.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---

Apologies for missing this patch earlier.

Applied to target-pending.

Thanks!

--nab

