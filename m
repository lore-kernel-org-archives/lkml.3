Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3HFQ0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:26:11 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42534 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3HFQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <5200BFB3.2050202@jp.fujitsu.com>
References: <5200BFB3.2050202@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Aug 2013 10:25:48 -0600
Message-ID: <CAErSpo5O8RbL=h5jrD3NkBhH6ARhMOag9JfUzPEED0cBfDSwxQ@mail.gmail.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        jingbai.ma@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:19 AM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> So, could anyone help testing the idea 2) above if you have which of
> the following machines? (or other ones that can lead to the same bug)
>
> - HP Compaq 6910p
> - HP Compaq 6710b
> - HP Compaq 6710s
> - HP Compaq 6510b
> - HP Compaq 2510p

Sorry, I don't have access to any of these machines any more, and I
don't have any useful advice for you.
