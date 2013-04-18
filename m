Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966558Ab3DRH6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:58:51 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:61126 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966510Ab3DRH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com>
References: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com>
Date: Thu, 18 Apr 2013 00:58:48 -0700
Message-ID: <CANN689FaU+1x8txgiDEhjTKV+QEBXRhA9J6hTRHu0+jJjsEyDQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
From: Michel Lespinasse <walken@google.com>
To: Libin <huawei.libin@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-mm@kvack.org, guohanjun@huawei.com,
        wangyijing@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 5:48 AM, Libin <huawei.libin@huawei.com> wrote:
> (*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
> as a inline funcion vma_pages() in linux/mm.h, so using it.
>
> Signed-off-by: Libin <huawei.libin@huawei.com>

Looks good to me.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
