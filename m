Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936852Ab3DKD4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:56:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35536 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935222Ab3DKD4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:56:22 -0400
X-Spam-Score: -100.8
Message-ID: <51663440.6030103@asianux.com>
Date: Thu, 11 Apr 2013 11:55:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <797985275.12108128.1365625781813.JavaMail.root@redhat.com>
In-Reply-To: <797985275.12108128.1365625781813.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 04:29, Eric Paris wrote:
> ----- Original Message -----
>> > 
>> > 
>> > in another function: audit_data_to_entry:
>> > 
>> >   a. has the same issue for case AUDIT_WATCH.
> You are saying if there were 2 of them it will leak the old one?  No.  If you have 2 AUDIT_WATCH entries the first one will set entry->rule->watch and the second will bomb with EINVAL in audit_to_watch()
> 
> 

  thanks, really it is. it is my fault.

  :-)


-- 
Chen Gang

Asianux Corporation
