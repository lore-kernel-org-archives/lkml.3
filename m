Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3CWQS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 12:18:58 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37505 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3CWQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <2281042.ltEMndsGee@vostro.rjw.lan>
References: <CAE9FiQVZ5VZDo1KCun6SDonTJ=TGWLxm5zJQN5U4f1_52cKKwg@mail.gmail.com>
	<CAE9FiQUarQVqzB_VSMqUrMvSHryrSN3_4tLTEJqygDFzB7uDUw@mail.gmail.com>
	<2281042.ltEMndsGee@vostro.rjw.lan>
Date: Sat, 23 Mar 2013 09:18:55 -0700
X-Google-Sender-Auth: FNlP_xO4ATX1WdGtpUVjuCNwzEY
Message-ID: <CAE9FiQWX15yH+7xgOZOg5XuLcoVEaJq3hononPkh5gYoC_C+zw@mail.gmail.com>
Subject: Re: pm/linux-next cause network stop working with qemu-kvm/e1000
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bob Moore <robert.moore@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>>
>> Attached patch fix the problem. Please fold it into offending patch in
>> pm/linux-next.
>
> I'd actually prefer to apply it as a separate patch, so can you please post
> it with a proper changelog?

but that will break bisecting, right?

Yinghai
