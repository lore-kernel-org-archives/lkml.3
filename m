Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3HQS0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 14:26:32 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34175 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3HQS0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 14:26:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130816131907.3338.76154.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
	<20130816131907.3338.76154.stgit@aruna-ThinkPad-T420>
Date: Sat, 17 Aug 2013 11:26:30 -0700
X-Google-Sender-Auth: TcYsCHk4KYLnTvAiXudoHEM2NAM
Message-ID: <CAGXu5jLzE3duC3vB8PTpvYroWmJDSU9ZSR3AKopKgRAwGZx4Fw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 11/11] pstore/ram: Read and write to the
 'compressed' flag of pstore
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, jkenisto@linux.vnet.ibm.com,
        ananth@in.ibm.com, benh@kernel.crashing.org,
        Anton Vorontsov <cbouatmailru@gmail.com>, mahesh@linux.vnet.ibm.com,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 6:19 AM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> In pstore write, add character 'C'(compressed) or 'D'(decompressed)
> in the header while writing to Ram persistent buffer. In pstore read,
> read the header and update the 'compressed' flag accordingly.
>
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>

Nice work!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
