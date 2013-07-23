Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab3GWPxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:53:15 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56552 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab3GWPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:53:13 -0400
Date: Tue, 23 Jul 2013 08:53:10 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
Subject: Re: [PATCH net-next] tuntap: hardware vlan tx support
Message-ID: <20130723085310.4a036a47@nehalam.linuxnetplumber.net>
In-Reply-To: <1374563748-38821-1-git-send-email-jasowang@redhat.com>
References: <1374563748-38821-1-git-send-email-jasowang@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 15:15:48 +0800
Jason Wang <jasowang@redhat.com> wrote:

> +		struct {
> +			__be16 h_vlan_proto;
> +			__be16 h_vlan_TCI;
> +		} veth;

Don't you want to use struct vlan_hdr here? 
Your definition puts the two fields out of order?
