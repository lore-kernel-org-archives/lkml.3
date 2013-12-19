Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3LSATk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:19:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53154 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab3LSATi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:19:38 -0500
Message-ID: <52B23B51.2030800@zytor.com>
Date: Wed, 18 Dec 2013 16:18:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
References: <20131218204024.30540.55302.stgit@bling.home>	<20131218210141.GA11267@kroah.com>	<52B21B7E.1020307@zytor.com> <20131218235526.4b4388d4@alan.etchedpixels.co.uk>
In-Reply-To: <20131218235526.4b4388d4@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 03:55 PM, One Thousand Gnomes wrote:
>> I think Alan Cox was the last person to man <device@lanana.org>... Alan,
>> are you still doing that?  (Otherwise patching the file in the Linux
>> kernel tree seems eminently sensible... there really isn't any need to
>> reserve numbers for out-of-tree drivers anymore.  Just another perk of
>> being in-tree.)
> 
> I am sort of but the mail alias hasn't worked for a long time afaik.
> 
> From the records I have 196 was never issued to anything in tree or
> mainstream in recent history so lets make it official ?
> 

I wonder if I have the RCS file from way back when...

	-hpa

