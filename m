Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3DSUwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:52:43 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35826 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3DSUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:52:41 -0400
Date: Fri, 19 Apr 2013 13:52:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mdadm raid1 regression
Message-ID: <20130419205238.GB1347@kroah.com>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 02:38:53PM +0400, Vasiliy Tolstov wrote:
> Hello. I'm using linux 3.8.6 and mdadm 3.2.6 (from git).
> I have many raid1 arrays that have data offset 2048 (metadata 1.2,
> created with various mdadm versions but mostly 3.2.1 on linux 2.6.32).
> If i create raid1 with never mdadm on 3.8.6 i have data offset 8192?? Why?

Please try asking this on the mailing list for the raid developers
(linux-raid@vger.kernel.org).

