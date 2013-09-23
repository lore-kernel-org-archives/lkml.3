Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3IWNoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3IWNoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:44:10 -0400
Message-ID: <524045B5.5020308@redhat.com>
Date: Mon, 23 Sep 2013 15:44:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <20130922074238.GG25202@redhat.com> <523EAFFA.6060203@redhat.com> <20130922095348.GJ25202@redhat.com> <524043C5.70700@windriver.com>
In-Reply-To: <524043C5.70700@windriver.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2013 15:36, Paul Gortmaker ha scritto:
>> > The change is not completely trivial, it splits lock. There is no
>> > obvious problem of course, otherwise you wouldn't send it and I
>> > would ack it :), but it does not mean that the chance for problem is
>> > zero, so why risk stability of stable even a little bit if the patch
>> > does not fix anything in stable?
>> > 
>> > I do not know how -rt development goes and how it affects decisions for
>> > stable acceptance, why can't they carry the patch in their tree until
>> > they move to 3.12?
> The -rt tree regularly carries mainline backports that are of interest
> to -rt but perhaps not of interest to stable, so there is no problem
> doing the same with content like this, if desired.

Perfect, I'll queue [v2 of] these patches for 3.12 then.

Paolo
