Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaFSJpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:45:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48094 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbaFSJpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:45:19 -0400
Message-ID: <53A2B12A.7070900@redhat.com>
Date: Thu, 19 Jun 2014 11:45:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider
 cs.l
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il> <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il> <53A1B33A.3080509@redhat.com> <53A1B7EE.7070800@gmail.com> <53A1B921.1050108@redhat.com> <E364EC9D-EC0D-43BC-B946-473CBFCAFAC1@gmail.com>
In-Reply-To: <E364EC9D-EC0D-43BC-B946-473CBFCAFAC1@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 19:51, Nadav Amit ha scritto:
> If you fix it, please fix both VMREAD and VMWRITE. If not, I would resubmit.

Yes, I'm fixing it myself.

Paolo
