Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaGVOgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:36:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35866 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaGVOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:36:31 -0400
Message-ID: <1406039784.2404.8.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 0/2] security: introduce kernel_fw_from_file hook
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 22 Jul 2014 10:36:24 -0400
In-Reply-To: <1405969601-4234-1-git-send-email-keescook@chromium.org>
References: <1405969601-4234-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072214-8236-0000-0000-000004078CED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 12:06 -0700, Kees Cook wrote: 
> This is a reduced version of the original patch. This adds only the LSM
> hook to the existing firmware loading logic so that the LSM can reason
> about the origin and contents of a firmware coming from userspace.
> 
> Thanks!
> 
> -Kees
> 
> v2:
> - further clarify header comments (jmorris)

Thanks Kees!  We now have module and firmware security hooks.  What's
next - kexec?

Please feel free to add my Acks.

Mimi

