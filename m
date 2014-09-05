Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaIEIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:06:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaIEIGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:06:40 -0400
Message-ID: <54096F0E.4010803@suse.com>
Date: Fri, 05 Sep 2014 10:06:38 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: david.vrabel@citrix.com, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen: sync some headers with xen tree
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-2-git-send-email-jgross@suse.com> <54087CAE0200007800030D79@mail.emea.novell.com>
In-Reply-To: <54087CAE0200007800030D79@mail.emea.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 02:52 PM, Jan Beulich wrote:
>>>> On 04.09.14 at 14:38, <"jgross@suse.com".non-mime.internet> wrote:
>> As the KEXEC and DUMPCORE related ELFNOTES are not relevant for the
>> kernel they are omitted from elfnote.h.
>
> But the defines are still in the patch:

Oops, old header version. I'll correct it.


Juergen

