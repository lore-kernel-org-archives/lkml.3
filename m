Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3EVUhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:37:05 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51150 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3EVUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:37:03 -0400
Message-ID: <519D2C63.7020002@redhat.com>
Date: Wed, 22 May 2013 22:36:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
References: <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org> <519CE9FE.2030007@redhat.com> <yq1vc6b561q.fsf@sermon.lab.mkp.net> <519CF99E.6010804@redhat.com> <20130522181135.GC20848@thunk.org> <519D1E92.7030505@redhat.com> <20130522201957.GD20848@thunk.org>
In-Reply-To: <20130522201957.GD20848@thunk.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/05/2013 22:19, Theodore Ts'o ha scritto:
> On Wed, May 22, 2013 at 09:37:54PM +0200, Paolo Bonzini wrote:
>>> If it's not theoretical, how does the cloud service control who has
>>> access to the CD burner, and how are the disks loaded into the CD
>>> burner?
>>
>> CD burning would be used in a VM that runs on your local workstation, so
>> the VM gets access to the CD burner under your desk.  There was also a
>> developer of a CD burning tool that wanted to test it inside BSD,
>> Solaris and Windows VMs; the idea is the same.
> 
> So in both cases all of the VM's and the host OS are within the same
> trust boundary.  This simplifies the security requirements than in the
> more generic cloud server caser where the VM's are mutually
> suspicious.  This simplifies the requirements of what we need to push
> into the kernel, yes?

What do you mean by "push into the kernel"?

(Anyway the CD burner case is really the only one that the current
whitelist covers completely.  I was just listing it as a use case for
SG_IO in the context as virtualization).

Paolo
