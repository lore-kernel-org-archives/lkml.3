Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaEFRBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaEFRBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:01:46 -0400
Message-ID: <5369156F.1070104@redhat.com>
Date: Tue, 06 May 2014 19:01:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Emulate VMXON region correctly
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>
In-Reply-To: <1399357158-8305-1-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/05/2014 08:19, Bandan Das ha scritto:
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521
>
> The vmxon region is unused by nvmx, but adding these checks
> are probably harmless and may detect buggy L1 hypervisors in
> the future!

Applied to kvm/queue, unit test patches are welcome (hint, hint!).

Paolo
