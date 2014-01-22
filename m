Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaAVHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:14:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaAVHOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:14:49 -0500
Message-ID: <52DF6FE7.2080901@suse.de>
Date: Wed, 22 Jan 2014 08:14:47 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] really large storage sectors - going beyond 4096
 bytes
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122052052.GM10565@ZenIV.linux.org.uk>
In-Reply-To: <20140122052052.GM10565@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 06:20 AM, Joel Becker wrote:
> On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
>> One topic that has been lurking forever at the edges is the current
>> 4k limitation for file system block sizes. Some devices in
>> production today and others coming soon have larger sectors and it
>> would be interesting to see if it is time to poke at this topic
>> again.
>>
>> LSF/MM seems to be pretty much the only event of the year that most
>> of the key people will be present, so should be a great topic for a
>> joint session.
> 
> Oh yes, I want in on this.  We handle 4k/16k/64k pages "seamlessly," and
> we would want to do the same for larger sectors.  In theory, our code
> should handle it with the appropriate defines updated.
> 
+1

The shingled drive folks would really love us for this.
Plus it would make live really easy for those type of devices.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
