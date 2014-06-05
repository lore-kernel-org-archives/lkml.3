Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaFEDKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:10:48 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58464 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaFEDKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <538F6DEB.2000601@redhat.com>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
	<1401881699-1456-6-git-send-email-pbonzini@redhat.com>
	<CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
	<538F6DEB.2000601@redhat.com>
Date: Wed, 4 Jun 2014 20:10:45 -0700
Message-ID: <CAHdzE--6krnQ2H9yyfNzX5Y4RoZs-XfKdmFzPufxpMp5hx33pQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] virtio-scsi: fix various bad behavior on aborted requests
From: Venkatesh Srinivas <venkateshs@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@parallels.com, stable@vger.kernel.org,
        Venkatesh Srinivas <vsrinivas@ops101.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/14, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 04/06/2014 19:29, Venkatesh Srinivas ha scritto:
>> Do you really want to poll the request VQs for completions if the TMF
>> was rejected?
>
> I wasn't sure, but bugs in this path are hard enough that I preferred
> the safer patch.

Ok. As long as it was deliberate. I'd slightly prefer only doing so in
the success case, but simplicity is a compelling argument :)

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
