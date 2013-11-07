Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3KGDMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:12:44 -0500
Received: from ozlabs.org ([203.10.76.45]:35583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab3KGDMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:12:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>,
        James Solner <solner@alcatel-lucent.com>, dhowells@redhat.com,
        jwboyer@fedoraproject.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] Add Documentation/module-signing.txt file
In-Reply-To: <527AA748.7070008@infradead.org>
References: <2816992.xgHeIJfXWn@cmlinux10.ih.lucent.com> <527AA748.7070008@infradead.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Nov 2013 13:32:16 +1030
Message-ID: <87r4as6hjb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:
> On 11/06/13 10:53, James Solner wrote:
>> This patch adds the Documentation/module-signing.txt file that is
>> currently missing from the Documentation directory. The init/Kconfig
>> file references the Documentation/module-signing.txt file to explain
>> how kernel module signing works. This patch supplies this documentation. 
>> 
>> The initial version of this patch provided old documentation
>> that was a mixture of the old RHEL style GPG signing. 
>> Version 1 updated the documentation to described the current
>> implementation using x509 certificate signing. 
>> Version 2, fixes grammar/spelling mistakes and removes
>> trailing whitespaces. Version 3, fixes grammar/spelling mistakes. 
>> 
>> Signed-off-by: James Solner <solner@alcatel-lucent.com>
>> 
>
> Looks good to me.  I'll let David, Josh, Rusty, et al, comment
> on the real content.

Once David Acks, I'll take it.

Thanks,
Rusty.
