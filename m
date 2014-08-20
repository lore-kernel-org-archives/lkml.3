Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaHTRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaHTRLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:11:33 -0400
Message-ID: <1408554623.11383.63.camel@ul30vt.home>
Subject: Re: LPC IOMMU and VFIO MicroConference - Call for Participation
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Arnd Bergmann <arnd@arndb.de>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ddutile <ddutile@redhat.com>, Jerome Glisse <j.glisse@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 20 Aug 2014 11:10:23 -0600
In-Reply-To: <20140812092019.GY9809@8bytes.org>
References: <20140812092019.GY9809@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok folks, it's time to submit your discussion proposals for the LPC
IOMMU and VFIO uconf.  If you added an idea to the wiki, now is the time
to formally propose it as a discussion topic.  If you have ideas how to
make the IOMMU or VFIO subsystems better, now is the time to propose it.
If you can't figure out how to make something work in the current
infrastructure, now is the time to propose a discussion.  If you're
adding new features and want to make sure we can support them, now is
the time to propose a discussion.

I don't think we've seen a formal schedule yet, but many of us have
conflicts with KVM Forum this year and I expect the LPC planning
committee to take that into account, so please submit your proposals
anyway and feel free to note your availability/conflicts in the "Note to
organizers" section.

LPC is full, but there is a waiting list and the sooner you can get on
it, the more likely you are to be registered.  I expect uconf discussion
leads to have an advantage in moving through the queue and we may be
able to provide discounted registration for discussion leads.  Thanks,

Alex

On Tue, 2014-08-12 at 11:20 +0200, Joerg Roedel wrote:
> LPC IOMMU and VFIO MicroConference - Call for Participation
> ===========================================================
> 
> We are pleased to announce that this year there will be the first IOMMU
> and VFIO MicroConference held at Linux Plumbers Conference in
> Düsseldorf. An initial request for support of this micro conference
> generated, among others, the following possible topic ideas:
> 
> 	* Improving generic IOMMU code and move code out of drivers
> 	* IOMMU device error handling
> 	* IOMMU Power Management
> 	* Virtualizing IOMMUs
> 	* Interface between IOMMUs an memory management
> 
> More suggested topics can be found at the wiki page of the micro
> conference:
> 
> 	http://wiki.linuxplumbersconf.org/2014:iommu_microconference
> 
> We now ask for formal proposals for these discussions along with any
> other topics or problems that need to be discussed in this area.
> 
> The format of the micro conference will be roughly half-hour slots for
> each topic, where the discussion lead gives a short introduction to the
> problem and maybe sketches possible solutions. The rest of the slot is
> open for discussions so that we come to an agreement how to move
> forward.
> 
> Please submit your formal proposal on the Linux Plumbers website (OpenID
> login required) until August 31st at:
> 
> 	http://www.linuxplumbersconf.org/2014/how-to-submit-microconference-discussions-topics/
> 
> Hope to see you in Düsseldorf!
> 
> 
> 	Joerg Roedel and Alex Williamson
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



