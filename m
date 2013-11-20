Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3KTDNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 22:13:38 -0500
Received: from ozlabs.org ([203.10.76.45]:59784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3KTDNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 22:13:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>,
        James Solner <solner@alcatel-lucent.com>
Cc: dhowells@redhat.com, Josh Boyer <jwboyer@fedoraproject.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Add Documentation/module-signing.txt file
In-Reply-To: <29909.1384452051@warthog.procyon.org.uk>
References: <3184360.WhYjmYFIyN@cmlinux10.ih.lucent.com> <29909.1384452051@warthog.procyon.org.uk>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Nov 2013 12:56:33 +1030
Message-ID: <878uwjdd0m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> James Solner <solner@alcatel-lucent.com> wrote:
>
>> This patch adds the Documentation/module-signing.txt file that is
>> currently missing from the Documentation directory. The init/Kconfig
>> file references the Documentation/module-signing.txt file to explain
>> how kernel module signing works. This patch supplies this documentation. 
>> 
>> The initial version of this patch provided old documentation
>> that was a mixture of the old RHEL style GPG signing. 
>> 
>> Version 1: Updated the documentation to described the current
>>            implementation using x509 certificate signing. 
>> 
>> Version 2: fixes grammar/spelling mistakes and removes
>>            trailing whitespaces. 
>> 
>> Version 3, fixes grammar/spelling mistakes. 
>> 
>> Version 4: Include updates from David Howells and fixes for
>>            spelling mistakes.            
>> 
>> Signed-off-by: James Solner <solner@alcatel-lucent.com>
>
> Signed-off-by: David Howells <dhowells@redhat.com>

?  I changed this to an Acked-by...

Cheers,
Rusty.
