Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaIXQsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:48:24 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52960 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaIXQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <5422F1F7.8010308@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>
	<5422F1F7.8010308@6wind.com>
Date: Wed, 24 Sep 2014 09:48:11 -0700
Message-ID: <CAHA+R7MM04ew=J8sHfSQERwoCAgEDfrGgtgRORqs3ePgtjVYWg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
From: Cong Wang <cwang@twopensource.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:31 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>> I think in this case your ID's are still available, but aren't you
>> providing a new way
>> for the inner netns device to escape which we are trying to avoid?
>
> It's why the ids depend on user ns. Only if user ns are the same we allow to
> get an id for a peer netns.

Too late, userns is relatively new, relying on it breaks our existing
assumption.
