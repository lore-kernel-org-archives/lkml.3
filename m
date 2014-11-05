Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKEW52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:57:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKEW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:57:26 -0500
Date: Wed, 5 Nov 2014 14:57:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : lustre : Fixed static symbol sparse warnings
Message-ID: <20141105225725.GA27095@kroah.com>
References: <1415116904-12392-1-git-send-email-gerb.stralko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415116904-12392-1-git-send-email-gerb.stralko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:01:44AM -0500, Jerry Stralko wrote:
> Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/lib-move.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Someone sent this same patch in before you did, make sure you are
working on the correct branch so as to not duplicate work.

sorry,

greg k-h
