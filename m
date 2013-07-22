Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab3GVSgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:36:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49407 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab3GVSgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:36:23 -0400
Message-ID: <51ED7B9A.1050004@zytor.com>
Date: Mon, 22 Jul 2013 11:36:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Brandon Philips <brandon@ifup.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
References: <20130719020603.GA22932@kroah.com> <20130719131819.GC11233@debian70-amd64.local.net-space.pl> <20130719151243.GA15488@kroah.com> <20130719183235.GA12267@debian70-amd64.local.net-space.pl> <20130719191449.GA1882@kroah.com> <51E9A85D.2060206@zytor.com> <20130722170307.GB14451@debian70-amd64.local.net-space.pl> <87wqoise9d.fsf@xmission.com> <51ED78EE.9020903@zytor.com> <20130722183315.GA29273@kroah.com>
In-Reply-To: <20130722183315.GA29273@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 11:33 AM, Greg KH wrote:
> 
> I don't care about kdump, I care about kexec on domU for people who are
> running on cloud providers with old versions of Xen so that they can
> control what kernel they can boot, when they want to boot it.  If kdump
> works as well, that's just a bonus, but it's down on the list of things
> for me to be concerned about.
> 

Another valid use case, to be sure.

	-hpa


