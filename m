Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3HNQlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:41:05 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33077 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3HNQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:41:01 -0400
Date: Wed, 14 Aug 2013 12:40:56 -0400 (EDT)
From: Jack Hill <jackhill@jackhill.us>
X-X-Sender: jackhill@pilot.trilug.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [ 04/23] SCSI: qla2xxx: Properly set the tagging for commands.
In-Reply-To: <20130802102036.810716252@linuxfoundation.org>
Message-ID: <alpine.DEB.2.02.1308141238220.31921@pilot.trilug.org>
References: <20130802102036.180660415@linuxfoundation.org> <20130802102036.810716252@linuxfoundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Apologies if this question is due to my ignorance of kernel development 
practices. Feel free to point me at documentation.

I noticed that you applied this patch to the 3.10, 3.4, and 3.0 trees. On 
kernel.org, it looks like 3.2 is also a longterm kernel. Why was this 
patch not applied to that tree?

Thanks!
Jack

