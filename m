Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaEMTXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:23:45 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48800 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaEMTXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1405132118200.16459@pobox.suse.cz>
References: <1400008501-7165-1-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1405132118200.16459@pobox.suse.cz>
Date: Tue, 13 May 2014 15:23:34 -0400
Message-ID: <CAN+gG=F12VK5xwB9UrRXEsOqj0iB8OOdEMwKZKWoSZRYmS29-A@mail.gmail.com>
Subject: Re: [PATCH] HID: rmi: fix duplicated argument to && or ||
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 3:18 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 13 May 2014, Benjamin Tissoires wrote:
>
>> This resulted from an unfortunate copy/paste.
>>
>> Detected automagically by kbuild.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> I have already fixed this in the tree after seeing Dan's email.
>
> Thanks, good catch!

Hey, thanks to you! :)

Cheers,
Benjamin
