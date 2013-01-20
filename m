Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3ATRAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 12:00:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42665 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3ATRAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 12:00:45 -0500
Message-ID: <50FC22AA.9040609@zytor.com>
Date: Sun, 20 Jan 2013 09:00:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, pjones@redhat.com, dhowells@redhat.com,
        jwboyer@redhat.com
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>  <1358285695-26173-3-git-send-email-vgoyal@redhat.com>  <1358437021.2689.52.camel@falcor1> <20130117155154.GC12165@redhat.com>  <1358440365.2689.72.camel@falcor1>  <adaba402-2f13-4e0b-ac06-143adaf6101b@email.android.com> <1358700917.2406.93.camel@falcor1.watson.ibm.com>
In-Reply-To: <1358700917.2406.93.camel@falcor1.watson.ibm.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2013 08:55 AM, Mimi Zohar wrote:
> On Sun, 2013-01-20 at 08:17 -0800, H. Peter Anvin wrote:
>> You then get into issues like: do we have to ban prelink as a result?
> 
> Once you change a file, the original signature shouldn't match.  If you
> really trust prelink, then make prelink a trusted application that can
> resign the modified file.  How to create/store/use private keys on the
> target system is a separate issue.
> 

That is true in a particularly brittle sense of the word, but it would
also be possible for the signature system to explicitly recognize the
transformation performed by prelink -- and no other -- before
verification.  That being said, that may be quite complex.

	-hpa


