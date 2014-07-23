Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaGWNIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:08:55 -0400
Received: from cpc2-cwma8-2-0-cust224.7-3.cable.virginm.net ([82.20.154.225]:57978
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751361AbaGWNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:08:54 -0400
Date: Wed, 23 Jul 2014 14:08:09 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>
Subject: Re: [PATCH] tty/n_gsm.c: get gsm->num after gsm_activate_mux
Message-ID: <20140723140809.6f2b51fd@alan.etchedpixels.co.uk>
In-Reply-To: <53CF56AD.5090902@intel.com>
References: <53CF56AD.5090902@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 14:31:09 +0800
"xinhui.pan" <xinhuix.pan@intel.com> wrote:

> gsm->num is the index of gsm_mux[], it's invalid before calling gsm_activate_mux.
> 
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>

Thanks

Acked-by: Alan Cox <alan@linux.intel.com>
