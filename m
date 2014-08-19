Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaHSOlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:41:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56601 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752134AbaHSOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:41:45 -0400
Date: Tue, 19 Aug 2014 10:41:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjun Sreedharan <arjun024@gmail.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: use kcalloc instead of kzalloc
In-Reply-To: <1408444681-1601-1-git-send-email-arjun024@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1408191041020.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Arjun Sreedharan wrote:

> kcalloc has protection from integer overflows
> which could arise from the multiplication of
> number of elements and size.
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>

As Clemens pointed out, integer overflows cannot occur here.  This 
patch is not needed.

Alan Stern

