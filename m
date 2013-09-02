Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3IBG3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab3IBG3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:29:13 -0400
Message-ID: <52243033.9000309@redhat.com>
Date: Mon, 02 Sep 2013 14:29:07 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] vhost_net: make vhost_zerocopy_signal_used() returns
 void
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com> <1377836962-49780-2-git-send-email-jasowang@redhat.com> <20130902055118.GB19838@redhat.com>
In-Reply-To: <20130902055118.GB19838@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 01:51 PM, Michael S. Tsirkin wrote:
> tweak subj s/returns/return/
>
> On Fri, Aug 30, 2013 at 12:29:17PM +0800, Jason Wang wrote:
>> > None of its caller use its return value, so let it return void.
>> > 
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>> > ---

Will correct it in v3.
