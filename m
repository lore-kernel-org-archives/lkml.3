Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3KFUcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:32:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3KFUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:32:17 -0500
Message-ID: <527AA748.7070008@infradead.org>
Date: Wed, 06 Nov 2013 12:32:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Solner <solner@alcatel-lucent.com>, dhowells@redhat.com,
        rusty@rustcorp.com.au, jwboyer@fedoraproject.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] Add Documentation/module-signing.txt file
References: <2816992.xgHeIJfXWn@cmlinux10.ih.lucent.com>
In-Reply-To: <2816992.xgHeIJfXWn@cmlinux10.ih.lucent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 10:53, James Solner wrote:
> This patch adds the Documentation/module-signing.txt file that is
> currently missing from the Documentation directory. The init/Kconfig
> file references the Documentation/module-signing.txt file to explain
> how kernel module signing works. This patch supplies this documentation. 
> 
> The initial version of this patch provided old documentation
> that was a mixture of the old RHEL style GPG signing. 
> Version 1 updated the documentation to described the current
> implementation using x509 certificate signing. 
> Version 2, fixes grammar/spelling mistakes and removes
> trailing whitespaces. Version 3, fixes grammar/spelling mistakes. 
> 
> Signed-off-by: James Solner <solner@alcatel-lucent.com>
> 

Looks good to me.  I'll let David, Josh, Rusty, et al, comment
on the real content.

Thanks.

> ---
>  Documentation/module-signing.txt | 115 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
>  create mode 100644 Documentation/module-signing.txt



-- 
~Randy
